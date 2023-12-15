;; As always we must define the module under a keyset
(namespace "free")
;; Define the critical keysets that are need to run smart contract operations
(define-keyset "free.kdabet-admin" (read-keyset "kdabet-admin"))
(define-keyset "free.kdabet-operation" (read-keyset "kdabet-operation"))
(define-keyset "free.kdabet-bank" (read-keyset "kdabet-bank"))

(module kai-mint GOVERNANCE
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; CAPABILITIES
  ;;-------------------------------------------------------
  ;; Capabilities are permissions granted to keysets to 
  ;; access functions of the smart contract module
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;Governance: Global tier access
  (defcap GOVERNANCE ()
    (enforce-guard (keyset-ref-guard "free.kdabet-admin" ))
    ;;Tacking on operations to the governance cap
    (compose-capability (OPS_INTERNAL))
  )
  
  ;;Operations: Managerment tier access 
  (defcap OPS()
    (enforce-guard (keyset-ref-guard "free.kdabet-operation"))
    ;;Tacking on operations 
    (compose-capability (OPS_INTERNAL))
    ;;Allows for Whitelist modification
    (compose-capability (WLMOD))
  )

  ;;Allows for the creation of a collection
  (defcap CREATECOL()
    true
  )

  ;;Allows for the operation of internal smart contract functions
  (defcap OPS_INTERNAL ()
    ;;Tacks on the ability to mint and ng token
    (compose-capability (MINT))
  )

  ;;Allows for updating of a whitelist entry
  (defcap WHITELIST_UPDATE ()
    true
  )

  ;;Allows for the capacity to mint an NG token
  (defcap MINT ()
    ;;Tacks on the ability to update a row in the whitelist
    (compose-capability (WHITELIST_UPDATE))
    ;;Tacks on the ability to perform a payment operation "Splitting"
    (compose-capability (SPLITTER))
  )

  ;;Allows for the modifcation of the whitelist table
  (defcap WLMOD ()
	  true
  )

  ;;Allows for a keyset to make a payment instruction if a guard is passed
  (defcap SPLITTER () true)

  ;;Events are emitted upon a MINT operation
  (defcap MINT_EVENT
    ;;The data we send to the event
    (
      collection:string
      tierId:string
      account:string
      amount:integer
    )
    @event true
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Schemas                           
  ;;-------------------------------------------------
  ;; Please refer to medium for explinations of the 
  ;; schemas purpose.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;The main collection schema
  (defschema collection
    name:string
    id:string
    totalSupply:integer
    creator:string
    creatorGuard:guard
    description:string
    currentIndex:integer
    fungible:module{fungible-v2}
    types:[object:{type}]
  )

  ;;Describes the type of nft in a collection
  (defschema type
    typeId:string
    startTime:time
    endTime:time
    cost:decimal
    limit:integer
    currencyType:string ;('KDA' or 'USD')
  )

  ;;Describes the actual nft token data
  (defschema token-data
    precision:integer
    uri:string
    policy:[module{marmalade-ng.token-policy-ng-v1}]
  )

  ;;Describes a minted token
  (defschema minted-token
    collection:string
    account:string
    guard:guard
    token-id:integer
    marmToken:string
    revealed:bool
  )

  ;;Descibes a whitelist entry
  (defschema whitelisted
    account:string
    typeId:string
    mint-count:integer
  )

  ;;Describes an entire NFT type whitelist
  (defschema type-whitelist-data
    tierId:string
    accounts:[string]
  )

  ;;Describes a fungible account that pays for the nft
  (defschema fungible-account
    account:string
    guard:guard
  )

  ;;Describes the current owner of the NFT
  (defschema nft
    id:string
    owner:string
  )
  
  ;;Describes the bank information
  (defschema bank-info
    value:string
  )

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;; Tables                          
  ;;-------------------------------------------------
  ;; Defines the table names where we store data.
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (deftable collections:{collection})
  (deftable minted-tokens:{minted-token})
  (deftable whitelist-table:{whitelisted})
  (deftable types:{type})
  (deftable tdata:{token-data})
  (deftable type-data:{type-whitelist-data})
  (deftable nft-table:{nft})
  (deftable bankInfo:{bank-info}) 
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Create the Critical Tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(if (read-msg "upgrade")
"Upgrade Complete"
[
  (create-table collections)
  (create-table bankInfo)
  (create-table minted-tokens)
  (create-table whitelist-table)
  (create-table types)
  (create-table tdata)
  (create-table type-data)
  (create-table nft-table)
]
)

