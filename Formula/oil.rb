class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.8.2.tar.gz"
  sha256 "f92ddf3fd39d7f8effccb21de719dff81045600d5e8f883f301d0d9db36a89d4"
  license "Apache-2.0"
  head "https://github.com/oilshell/oil.git"

  bottle do
    sha256 "38ff82b2a9792212b4fe218c9cca824642090b9ff5d8f2e0d595c56e5bf37659" => :catalina
    sha256 "14201c3b8aef65af80c4f54018f6393042491dab629e25cc9ddcecdb532d9308" => :mojave
    sha256 "88edd8bee8e6509e565ef943fcf42ea7cf9b83678a873c3d0d06332b81c13569" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "./install"
  end

  test do
    assert_equal pipe_output("#{bin}/osh -c 'pwd'").strip, testpath.to_s
  end
end
