defmodule KdabetFrontendWeb.About do
  use KdabetFrontendWeb, :surface_live_view
  alias KdabetFrontendWeb.Components.{BoardMember}

  def render(assigns) do
    ~F"""
    <div class="flex flex-col xl:flex-row w-full h-fit xl:h-[85vh] overflow-hidden">
      <!-- About us -->
      <section class="fader mt-5 w-full md:w-5/6 lg:w-5/6 xl:w-1/2 justify-center m-auto xl:justify-start h-full overflow-hidden invisible-scroll overflow-y-scroll">
        <h2 class="fade_title w-full text-center xl:text-right pb-5 text-[3em] md:text-[4em] xl:text-[5.5em] block md:hidden">ABOUT US</h2>
        <article class="glasscard p-[30px] lg:p-[50px] mt-[20px]">
          <h2 class="glowtext mb-8 text-2xl">KDAbet is a pure, decentralized sportsbook.</h2>
          <p class="glowtext mb-3">KDAbet is an experimental U.S sports and E-sports entertainment platform running on the Kadena L1 network.</p>
          <p class="glowtext mb-3">The KDAbet platform is the first prediction market of its kind, where the operation has no owners, board of directors, company structure or token.  The automated bookmaking system is overseen only via a decentralized autonomous organization (DAO) that collectivizes its progression over time via a fair vote.</p>
          <span class="hidden md:block">
            <p class="glowtext mb-3">The DAO is run by the community of NFT holders whose hash unlocks part of a open and observable smart contract in order to benefit from stewardship of the operation's profitability</p>
            <p class="glowtext mb-3">As the network increases in size, so does its decentralization and the distribution of its rewards via the generation of more NFTs by the Kadena King NFT.  Unlike traditional bookmaking and recent attempts to make web3 style prediction markets, We as a community optimize this system to maximize growth and decentralization of the network while minimizing costs to the end consumer.</p>
            <p class="glowtext mb-3">KDAbet is completely open source and has no ownership.   Our Network is our strength.</p>
          </span>
        </article>
        <article class="glasscard block md:hidden mt-10 p-[30px] lg:p-[50px]">
          <h2 class="glowtext mb-8 text-2xl">Strict DAO based management.</h2>
          <p class="glowtext mb-3">The DAO is run by the community of NFT holders whose hash unlocks part of a open and observable smart contract in order to benefit from stewardship of the operation's profitability</p>
          <p class="glowtext mb-3">As the network increases in size, so does its decentralization and the distribution of its rewards via the generation of more NFTs by the Kadena King NFT.  Unlike traditional bookmaking and recent attempts to make web3 style prediction markets, We as a community optimize this system to maximize growth and decentralization of the network while minimizing costs to the end consumer.</p>
          <p class="glowtext mb-3">KDAbet is completely open source and has no ownership.   Our Network is our strength.</p>
        </article>
      </section>
      <hr class="block xl:hidden mt-10 mb-5 border-sky-900">
      <!-- side image -->
      <section class="flex flex-col w-full xl:w-1/2">
        <h2 class="fade_title w-full text-center xl:text-right pb-5 text-[3em] md:text-[4em] xl:text-[5.5em]">DAO BOARD</h2>
        <BoardMember twitterurl="https://twitter.com/Kadenabet">
          <:name>Stephen Rothwell</:name>
          <:twitter><FontAwesome.LiveView.icon name="twitter" type="brands" class="social-icon2" /></:twitter>
          <:image><img class="w-[100px] h-[100px]" src="/images/stephen.png"></:image>
          <:blurb>15+ yrs experience in professional sports betting. 10+ years experience building PAM systems and AI driven oddsmaking software. 3 Exits in sports betting and 1 IPO in 2020.</:blurb>
        </BoardMember>
        <BoardMember twitterurl="https://twitter.com/DeFifutures">
          <:name>Sam Bradbury</:name>
          <:twitter><FontAwesome.LiveView.icon name="twitter" type="brands" class="social-icon2" /></:twitter>
          <:image><img class="w-[100px] h-[100px]" src="/images/sam.png"></:image>
          <:blurb>10+ yrs experience in Casino Gaming. Owner of <a class="text-blue-400" href="https://www.bbgamesltd.com/">BB games</a>, managing and selling over 3 dozen slot games to large scale operators. 10+ years business development in the I-gaming space.</:blurb>
        </BoardMember>
        <h2 class="fade_title w-full text-center xl:text-right pb-5 text-[3em] md:text-[4em] xl:text-[5.5em]">AFFILIATES</h2>
        <BoardMember twitterurl="/about">
          <:name>TBA</:name>
          <:twitter><FontAwesome.LiveView.icon name="twitter" type="brands" class="fill-slate-500" /></:twitter>
          <:image><img class="w-[100px] h-[100px]" src="/images/door.png"></:image>
          <:blurb>A major partner to be announced when we go live with the dapp.</:blurb>
        </BoardMember>
      </section>
    </div>
    """
  end
end
