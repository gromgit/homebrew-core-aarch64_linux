class Aerc < Formula
  desc "Email client that runs in your terminal"
  homepage "https://aerc-mail.org/"
  url "https://git.sr.ht/~rjarry/aerc/archive/0.9.0.tar.gz"
  sha256 "b5901feb37a55edd1f713e76c1012ac3fc0757202ddacd7d388cc7ce60638023"
  license "MIT"
  head "https://git.sr.ht/~rjarry/aerc", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aerc"
    sha256 aarch64_linux: "40669a887923da7ee73a1c36060bbb450b7156ae0f5ef393a66e243e9b5dd6a9"
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
