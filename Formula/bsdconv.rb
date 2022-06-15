class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/11.6.tar.gz"
  sha256 "e856e24474deb3731ac059a96af0078ba951895f2cb3b31f125148a29cc32b70"
  license "BSD-2-Clause"
  head "https://github.com/buganini/bsdconv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bsdconv"
    sha256 aarch64_linux: "275cc4427d57f867b63cbc2d5e92496ec455c45e6752869d9f2cf86daeed64f2"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134")
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
