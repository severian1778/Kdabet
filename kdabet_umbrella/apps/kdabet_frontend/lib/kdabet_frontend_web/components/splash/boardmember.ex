defmodule KdabetFrontendWeb.Components.BoardMember do
  @moduledoc """
  A sample component generated by `mix surface.init`.
  """
  use Surface.Component

  @doc "The header slot"
  slot name

  @doc "The footer slot"
  slot image

  @doc "The Twitter Icon"
  slot twitter

  @doc "The twitter url"
  prop twitterurl, :string, required: true

  @doc "The main content slot"
  slot blurb

  def render(assigns) do
    ~F"""
    <div class="w-full flex justify-center xl:justify-end px-5 mb-10">
      <div class="overflow-hidden rounded-md border-t border-l border-t-stone-100 border-l-stone-100 w-[100px] h-[100px] mr-5">
        <#slot {@image} />
      </div>
      <div class="flex flex-col text-stone-300 w-4/6">
        <div class="flex flex-row font-bold justify-between content border-b border-zinc-600 border-width-1">
          <h1 class="text-xl"><#slot {@name} /></h1>
          <a href={@twitterurl} class="h-6 w-6">
            <#slot {@twitter} />
          </a>
        </div>
        <div class="footer mt-2">
          <#slot {@blurb} />
        </div>
      </div>
    </div>
    """
  end
end
