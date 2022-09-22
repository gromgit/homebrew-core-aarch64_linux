class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.11.0.tar.gz"
  sha256 "3d8f3a2800946fce070e3eb02122e77c427a61c670a06337539b3e7f09e57861"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aerc"
    sha256 aarch64_linux: "a34450838bc2349a6e71a6cfc4e2e5e3dfc67ff9b42e66fd40b096a96ad674c6"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/aerc", "-v"
  end
end
