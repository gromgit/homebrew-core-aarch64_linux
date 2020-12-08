class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.5.0.tar.gz"
  sha256 "d90d5a54e5ea4c2e6bd296f950b3f9059dd1a5801e306b475421d6344489d917"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c85dbea7452b24e36c4932a3845ddc69d08a2eaa05f7dc5ddad97558d8c70c48" => :big_sur
    sha256 "bb7d836b564b044cb52dfc8251ef55eb103ae5233465ff6c7336a42b057b73cd" => :catalina
    sha256 "f0f938120734f158cccbdb635e017dc3226acb911ca417973abd7bc9e272b505" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    prefix.install_metafiles
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
