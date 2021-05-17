(define-non-fungible-token non-fungible-token uint)

;; STORAGE
(define-map tokens-spender uint principal)
(define-map tokens-count principal uint)
(define-map accounts-operator (tuple (operator principal) (account principal))
(tuple (is-approved bool)))

;; Internals

;; Gets the amount of tokens owned by the specified address.
(define-private (balance-of (account principal))
  (default-to u0 (map-get? tokens-count account)))

;; Gets the approved address for a token ID, or zero if no address set (approved method in ERC721)
(define-private (is-spender-approved (spender principal) (token-id uint))
  (let ((approved-spender
         (unwrap! (map-get? tokens-spender token-id)
                   false))) ;; return false if no specified spender
    (is-eq spender approved-spender)))

    ;; Tells whether an operator is approved by a given owner (isApprovedForAll method in ERC721)
(define-private (is-operator-approved (account principal) (operator principal))
(default-to false
(get is-approved
(map-get? accounts-operator {operator: operator, account: account))))