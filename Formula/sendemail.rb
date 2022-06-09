class Sendemail < Formula
  desc "Email program for sending SMTP mail"
  # Alternate: https://freshmeat.sourceforge.io/projects/sendemail/
  homepage "https://web.archive.org/web/20191013154932/caspian.dotconf.net/menu/Software/SendEmail/"
  url "http://caspian.dotconf.net/menu/Software/SendEmail/sendEmail-v1.56.tar.gz"
  sha256 "6dd7ef60338e3a26a5e5246f45aa001054e8fc984e48202e4b0698e571451ac0"
  license "GPL-2.0+"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/sendemail"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5f91bdf245425860a812cf3ebd632df3708d12797a6ba2c35ba40f97621270f3"
  end

  # Reported upstream: https://web.archive.org/web/20191013154932/caspian.dotconf.net/menu/Software/SendEmail/#comment-1119965648
  patch do
    url "https://raw.githubusercontent.com/mogaal/sendemail/e785a6d284884688322c9b39c0f64e20a43ea825/debian/patches/fix_ssl_version.patch"
    sha256 "0b212ade1808ff51d2c6ded5dc33b571f951bd38c1348387546c0cdf6190c0c3"
  end

  def install
    bin.install "sendEmail"
  end

  test do
    assert_match "sendemail-#{version}", shell_output("#{bin}/sendemail", 1).strip
  end
end
