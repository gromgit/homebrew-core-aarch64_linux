class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.16.2.tar.gz"
  sha256 "c2c923bde3d6bad1790664dcd72fff6ca9f135656b5e19f862d3ad706a4b54ff"
  license "MIT"
  version_scheme 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9335a9131cb422d7bc04f879c23b7b77d998eab8134320f0dbc23d1aff46a46b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14acc3ba0c3e0467d9bfb8fa00732d474ab6a4544260f049110fe19fbb80bb3d"
    sha256 cellar: :any_skip_relocation, monterey:       "c1d46818af3913f31c842c9bb4f94ec2f7c094a236c65b98a016ee27e54e1011"
    sha256 cellar: :any_skip_relocation, big_sur:        "b29772a0bf905900d88026254e9c7191aeabd2da9e00e7474de64db24a38f2c1"
    sha256 cellar: :any_skip_relocation, catalina:       "6573a0968c0ba5d9f48c116194bbfd51ce20cc472dd6a7e68fe3fb96d1325482"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2869a76912481893adb214e0d5dfb578ab62e717d1b6c944e89a699475d99b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"dnsconfig.js").write <<~EOS
      var namecom = NewRegistrar("name.com", "NAMEDOTCOM");
      var r53 = NewDnsProvider("r53", "ROUTE53")

      D("example.com", namecom, DnsProvider(r53),
        A("@", "1.2.3.4"),
        CNAME("www","@"),
        MX("@",5,"mail.myserver.com."),
        A("test", "5.6.7.8")
      )
    EOS

    output = shell_output("#{bin}/dnscontrol check #{testpath}/dnsconfig.js 2>&1").strip
    assert_equal "No errors.", output
  end
end
