class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.3.tar.gz"
  sha256 "eb7bf657813a8b1cd6da2751744b4ec38bf4ebd4c11bf9deece84dd6ba8d97ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81a116c5312cd897908c1dedb810b86b587c004a7f19834027307b9fe4a58939"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "537b25d90af1e02b82cf2d74710f44da2b721b6f4080d95b818fa8d18328c463"
    sha256 cellar: :any_skip_relocation, monterey:       "b4def150155774fd0fa4f961ae9cad6940dd3ab83219a815f9ee3eb1fd1e39e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "47d3926d35be827f438499cf60ce9d0c1f58dc12d87421258b83dad30d96fcf3"
    sha256 cellar: :any_skip_relocation, catalina:       "6015049097a7ed11db210cbb37b403471552084002bb46f602a2a6f1a1737561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6f06b78c48d0c80f8b54ba01c28bed32ac6022f5a5568fc0443130c67e0e73c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
