---
title: Understanding Data Inscriptions on Ethereum
date: 2023-06-14 15:00 MST
tags: Web3, Inscriptions
excerpt: "&quot;So they're like Bitcoin Ordinals... but, for Ethereum? Is this another NFT thing?&quot; Let's talk Inscriptions! We're not handing out diplomas, but this is probably the next best thing."
banner:
  img: /images/getting-inscribed.jpg
  alt: Abstract art
  cap: image courtesy of <a href="https://www.pexels.com/@adrian-boustead-349435/">Adrian Boustead</a>, CC0
---

If you've heard of Ethscriptions but aren't sure where to start, then this is the right place. Here we'll explore the related concepts in plain language and to evaluate the merits and limitations of the approach.

First things first, let's clarify the terminology. An "Inscription" refers to the general approach of adding encoded data to an Ethereum transaction. On the other hand, an "Ethscription" is a specific format for encoding the data in these transactions in a way that its protocol can understand and extend. From here on out, I'll refer to the generic approach as an Inscription and the specific protocol as an Ethscription.

So, what exactly _are_ Inscriptions on Ethereum? At its core, an Inscription is simply an Ethereum transaction with extraneous call data added to it. "Call data" is primarily meant for adding data that "calls" a function on a contract. However, all transactions have the ability to include call data, regardless of whether the transaction targets a contract or not.

Why should you care? Well, transactions are naturally the most affordable actions you can perform on Ethereum. Inscriptions leverage this advantage, allowing you to record data on-chain in a cost-effective manner without the need to deploy a smart contract. The ability to store various types of data on-chain at a low cost opens up intriguing possibilities and potential applications worth exploring.

### Background

Inscriptions on Ethereum pay direct homage to Inscriptions on Bitcoin. Inscriptions on Bitcoin in turn require that you use a client that makes use of Ordinal Theory (you can read more about it in [this excellent blog post](https://unchained.com/blog/bitcoin-inscriptions-ordinals/)) so that there can be some notion of transferring individual Satoshis, which are the smallest unit of currency in bitcoin. This, in turn, allows people to associate a data inscription with an individual Satoshi. That individual Satoshi "owns" the inscription and can be traded.

Neither Ordinal Theory, its notion of counting and ordering Satoshis, nor the specific implementation of inscribing data on Bitcoin transactions are part of the Bitcoin protocol as of this writing. Viewed through the most generous lens, this is a great example of the hacker spirit: it embraces the constraint of the lack of smart contracts in Bitcoin, but leverages what possibilities are present, supplementing them externally where necessary.

### How Ethscriptions Work

Ethscriptions have four important facets. The format of their encoding, the tracking and attribution of ownership, their method of transfer and an off-chain facilitation component: the indexer.

**Encoding**

If an Inscription is the act of appending extra call data to a transaction, then an Ethscription is a specific format for that call data to be encoded in. The Ethscription protocol embraces the [open standard for Data URLs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/Data_URLs) to define its encoding. Data URLs, in turn, can include their own data and specify its mime type, so that it can be rendered by a variety of existing clients (typically web browsers). 

**Ownership**

Understanding the ownership for the originating inscription is pretty straightforward: by convention, the recipient of the transaction that contains the Inscription is considered to be the owner. In order to have a notion of ownership that could include transferability though, we need something else to keep track of both the originating transaction and a way to indicate that the data there has a new owner. The Ethscriptions protocol uses transaction hashes as a reference to solve this problem. In order to understand how that can track ownership over time though, we'll first need to discuss the convention for transferring an Ethscription.

**Transfers**

Another important convention of the protocol is the significance of referencing the transaction hash of an Inscription. If you become the "owner" of the originating Ethscription by being its recipient, then how does someone else become its new owner?

One possible solution might have been to simply inscribe that data once again in a transaction to its new owner. This is obviously not space efficient though, and it also introduces a new problem of how to account for the provenance of any transaction that might also happen to have that same data... who is the true "owner" if it just gets repeated over and over again. 

Ethscriptions chose to solve this problem by establishing the convention that a transfer of ownership could happen by referencing the transaction hash of the inscription in a new transaction from the owner to a new recipient. Subsequent transfers reference the transaction hash of the transaction that established the recipient as the owner. Over time, this forms a traceable series of transactions each pointing back to the transaction they received ownership of the Inscription, thereby establishing provenance pointing all the way back to the original.

**Indexer**

What's explained above is a method for establishing ownership and provenance of an inscription using a specific type of encoding. If you actually wanted to confirm these details though, it would be a lot of legwork, and you'd spend time looking at largely incomprehensible transaction data on a block explorer like Etherscan. This is where the Ethscriptions indexer program comes in.

The indexer is an off-chain program that inspects every transaction on Ethereum, finds those that conform to the Ethscriptions protocol, and keeps a public record of how the protocol has been interacted with. It is essentially a time-saving utility that provides a convenient way to look up any given Ethscription and get information about it. The indexer also does another job that we haven't discussed yet and that is invalidating non-conforming or incorrectly formatted Ethscriptions.

Invalidating Ethscriptions are another thing that's necessary to make provenance of ownership work effectively and without constant dispute. Without the indexer invalidating some Ethscriptions, there would be nothing to stop a future Ethscription with the same data from being considered equally valid. Stating that slightly differently, the indexer will only consider an Ethscription valid if it is the first Ethscription that has ever inscribed that exact data payload. Invalidation is also necessary to prevent multiple "transfers" from the same owner.

One other important note: while Ethscriptions currently make no effort to embrace Ordinal Theory, I wouldn't be terribly surprised if someone didn't suggest it in the near future. As it stands, individual transaction hashes and an external indexer stand in the place of it and supply much of the same functionality.

### Getting outside the protocol

In my opinion, the most fascinating aspect of Inscriptions is their ability to decouple data storage from its interpretation. Traditional smart contracts require deploying a custom contract to store and interpret specific data types. NFTs, DeFi apps, on-chain governance—all rely on smart contracts to both store and interpret data.

The separation of data storage from its interpretation is a big deal. Just consider formats like JPEG and HTML, where storing data separately from how it's interpreted opens up incredible possibilities. HTML itself has evolved tremendously over time. With Inscriptions, we're just scratching the surface of what's possible. It feels like a wide-open door to a world of exciting opportunities.

As of today, Inscriptions have been predominantly used as an alternative to NFTs. For instance, the recently launched [testnet marketplace for Ethscriptions](https://goerli.ethscriptions.com/) puts a major emphasis on selling image-based Inscriptions. This is informed heavily by how Bitcoin's Ordinals use Inscriptions. It's a natural fit and makes a lot of sense, but in my estimation, the genius of this approach lies in transforming the most cost-effective transactions on Ethereum into a means of storing virtually any data in text or binary form.

**Use Cases for Inscriptions**

Perhaps one of the better ways to explore the versatility of Inscriptions would be to explore some potential use cases of the approach. Here are a few potential ways I can see it being used in ways that don't necessarily need the full Ethscriptions approach:

- **Data Storage:** Inscriptions offer a secure and efficient method to store data on-chain for off-chain processing. By circumventing the need for direct storage on smart contracts, Inscriptions can reduce costs while ensuring data accessibility.
- **Decentralized Identifiers (DIDs):** Inscriptions can serve as a means to store and manage DIDs, which provide unique identifiers for individuals, organizations, or entities in decentralized systems. Leveraging Inscriptions, DIDs can be securely stored and managed on-chain, facilitating self-sovereign identity solutions.
- **Governance and Voting:** Inscriptions enable transparent and auditable governance processes by recording voting or decision-making data on the blockchain. This empowers verifiable and accountable governance systems, ensuring integrity and transparency in voting outcomes.
- **Time-stamping and Proofs:** Inscriptions provide the ability to create tamper-proof timestamps for critical documents, intellectual property, or digital assets. By storing a hash or reference to the original content on-chain, Inscriptions offer verifiable proof of existence or ownership at specific points in time.

### Limitations

While Inscriptions offer some exciting possibilities, there are some inherent limitations to consider:

* **Transaction Size**: Inscriptions are subject to transaction size limitations. Since larger transactions are often less profitable, block inclusion may not be timely and very large transactions may not get mined at all. A soft limit of 90 KB has been proposed by the Ethscriptions protocol.
* **Off-Chain Processing**: Although Inscriptions store data on-chain, it's crucial to remember that smart contracts can only access transaction data when the transaction is explicitly directed at that contract. So, if you want to process Inscription data, you'll need to do it off-chain.
* **Readability and Efficiency**: Choose one. While Inscriptions are inherently flexible in the data you can store, encoding choices will tend to mean that you can have either human readability or storage efficiency. Balancing the expressive power of JSON or plain text with space efficient binary encodings will be an important consideration.
* **Trust Model**: Due to the trade-offs in on-chain storage and off-chain processing, it may be difficult to achieve the trustlessness that is so often sought after in Web3. Off-chain processors in particular will have to work harder to establish trust than the transparent, completely on-chain processing we're more accustomed to.
* **Interoperability and Standards**: Ethscriptions, as a protocol definition on top of Ethereum transactions, represents an initial effort to establish a standard for Inscriptions. However, it is important to acknowledge that Ethscriptions is a relatively high-level and opinionated take, which leaves room for the emergence of competing standards for Inscriptions.

### In Summary

Ethscriptions bring a fantastic addition to the Ethereum development toolbox. They are not a one-size-fits-all solution, but they open doors to exciting new possibilities. If you're building on Layer 2 solutions that include transaction data in their L1 roll-ups (like Optimistic Roll-ups), Inscriptions could be a game changer. They're an incredibly cost-effective method to propagate data up to the Layer 1. More generally, this approach allows us to explore more innovative ways to leverage the Ethereum ecosystem and could enable some completely new paradigms. These remain exciting times!