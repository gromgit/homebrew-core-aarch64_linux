class BoreCli < Formula
  desc "Modern, simple TCP tunnel in Rust that exposes local ports to a remote server"
  homepage "http://bore.pub"
  url "https://github.com/ekzhang/bore/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "ab1f3e924ce8a32eafe842de0bb1d23eeeb397ec0ad16455b443206f0c9ee59d"
  license "MIT"
  head "https://github.com/ekzhang/bore.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bore-cli"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bd2329101eeb998218898c9764230d28552997ebc5cf92a3c30fc52ca937fcfd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    _, stdout, wait_thr = Open3.popen2("#{bin}/bore server")
    assert_match "server listening", stdout.gets("\n")

    assert_match version.to_s, shell_output("#{bin}/bore --version")
  ensure
    Process.kill("TERM", wait_thr.pid)
    Process.wait(wait_thr.pid)
  end
end
