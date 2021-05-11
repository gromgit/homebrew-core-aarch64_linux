class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.8.tar.gz"
  sha256 "87f8251742123d5c70eb3416e9dd71e9db693a966dd8d9aa8c30630bdba1dc11"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1019bd007e582d30f0316400696b58aef0929c937646a1840a087e0908cb2866"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa9a6fecf160d3e837162d63cf0a183fff736ed60fe2630b4b51c7b62e88ec19"
    sha256 cellar: :any_skip_relocation, catalina:      "323812cd18ac17b5d22a31fb2341df5888671259b253ed14e1b80a112f9aa812"
    sha256 cellar: :any_skip_relocation, mojave:        "3b1142a728214c758411cfffbf4bb455b22fd0ebccde21aca0710c376b246f15"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
