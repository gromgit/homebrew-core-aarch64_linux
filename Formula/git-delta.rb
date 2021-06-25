class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.1.tar.gz"
  sha256 "e478acf90c1125af0cfcb055c1e2b358080d192fbf83cf5ddfa40241830ab826"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d561484b9cf9d315d3cd2770f340a53341175f785cd5a2d561c0549b3334ab88"
    sha256 cellar: :any_skip_relocation, big_sur:       "ce955a6b9dc0fd8b00aece1189d1c5682de2f790a9f2d59573765e7c910940fa"
    sha256 cellar: :any_skip_relocation, catalina:      "7d9a33295175b4093b3448a087850737a40e292bc958cb38d5af8ea406c8d737"
    sha256 cellar: :any_skip_relocation, mojave:        "88c0109e70a500fa49f4ddaa8a3eb28110e3d4efb8da62f1dbaea7ae948a6d7a"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
