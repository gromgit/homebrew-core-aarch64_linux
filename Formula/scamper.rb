class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20211212.tar.gz"
  sha256 "ae4f84aef28373701568a9e57ec44a31ec20871c33c044a5272de726acbd2d13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/scamper"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d31336bb9e1f70e3074792eb653fc9d4260b7b7e44b6ef2ffd385356855a972d"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scamper -v 2>&1", 255)
  end
end
