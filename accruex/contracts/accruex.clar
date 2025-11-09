;; Token-based Loyalty Program Smart Contract

;; Error Constants
(define-constant error-not-authorized (err u100))
(define-constant error-insufficient-balance (err u101))
(define-constant error-invalid-amount (err u102))
(define-constant error-reward-unavailable (err u103))

;; Data Maps
(define-map user-balance-registry principal uint)
(define-map reward-catalog uint {reward-name: (string-ascii 50), reward-cost: uint, available-quantity: uint})

;; Contract Variables
(define-data-var loyalty-token-name (string-ascii 50) "LoyaltyToken")
(define-data-var loyalty-token-symbol (string-ascii 10) "LYT")
(define-data-var contract-owner principal tx-sender)
(define-data-var next-reward-id uint u0)

;; Read-only functions
(define-read-only (get-name)
  (ok (var-get loyalty-token-name))
)

(define-read-only (get-symbol)
  (ok (var-get loyalty-token-symbol))
)

(define-read-only (get-balance (user-account principal))
  (ok (default-to u0 (map-get? user-balance-registry user-account)))
)

(define-read-only (get-reward (reward-identifier uint))
  (map-get? reward-catalog reward-identifier)
)

;; Public functions
(define-public (transfer (token-amount uint) (token-sender principal) (token-recipient principal))
  (let ((sender-balance (default-to u0 (map-get? user-balance-registry token-sender))))
    (asserts! (is-eq tx-sender token-sender) (err error-not-authorized))
    (asserts! (<= token-amount sender-balance) (err error-insufficient-balance))
    (asserts! (> token-amount u0) (err error-invalid-amount))
    
    (map-set user-balance-registry token-sender (- sender-balance token-amount))
    (map-set user-balance-registry token-recipient (+ (default-to u0 (map-get? user-balance-registry token-recipient)) token-amount))
    (ok true)
  )
)

(define-public (mint (token-amount uint) (token-recipient principal))
  (let ((current-balance (default-to u0 (map-get? user-balance-registry token-recipient))))
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err error-not-authorized))
    (asserts! (> token-amount u0) (err error-invalid-amount))
    
    (map-set user-balance-registry token-recipient (+ current-balance token-amount))
    (ok true)
  )
)

(define-public (add-reward (reward-name (string-ascii 50)) (reward-cost uint) (available-quantity uint))
  (let ((reward-identifier (var-get next-reward-id)))
    (asserts! (is-eq tx-sender (var-get contract-owner)) (err error-not-authorized))
    (asserts! (> reward-cost u0) (err error-invalid-amount))
    (asserts! (> available-quantity u0) (err error-invalid-amount))
    
    (map-set reward-catalog reward-identifier {reward-name: reward-name, reward-cost: reward-cost, available-quantity: available-quantity})
    (var-set next-reward-id (+ reward-identifier u1))
    (ok reward-identifier)
  )
)

(define-public (redeem-reward (reward-identifier uint))
  (let (
    (reward-details (unwrap! (map-get? reward-catalog reward-identifier) (err error-reward-unavailable)))
    (user-balance (default-to u0 (map-get? user-balance-registry tx-sender)))
  )
    (asserts! (>= user-balance (get reward-cost reward-details)) (err error-insufficient-balance))
    (asserts! (> (get available-quantity reward-details) u0) (err error-reward-unavailable))
    
    (map-set user-balance-registry tx-sender (- user-balance (get reward-cost reward-details)))
    (map-set reward-catalog reward-identifier 
      (merge reward-details {available-quantity: (- (get available-quantity reward-details) u1)})
    )
    (ok true)
  )
)

;; Initialize contract
(begin
  (var-set contract-owner tx-sender)
)