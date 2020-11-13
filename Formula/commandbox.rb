class Commandbox < Formula
  desc "CFML embedded server, package manager, and app scaffolding tools"
  homepage "https://www.ortussolutions.com/products/commandbox"
  url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.2.0/commandbox-bin-5.2.0.zip"
  sha256 "68c706ba4c69b39ad82fbe189ae7d89d46e8f47caa80907f2b157bd3070494e5"

  livecheck do
    url :homepage
    regex(/Download CommandBox v?(\d+(?:\.\d+)+)/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  resource "apidocs" do
    url "https://downloads.ortussolutions.com/ortussolutions/commandbox/5.2.0/commandbox-apidocs-5.2.0.zip"
    sha256 "e5c6812a9f0130a0f20d9b7fc06fb14529aa9d74ff70f4cdf5db9f34f2c91c11"
  end

  def install
    bin.install "box"
    doc.install resource("apidocs")
  end

  test do
    system "#{bin}/box", "--commandbox_home=~/", "version"
    system "#{bin}/box", "--commandbox_home=~/", "help"
  end
end
