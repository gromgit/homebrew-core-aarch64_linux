class Dnscontrol < Formula
  desc "It is system for maintaining DNS zones"
  homepage "https://github.com/StackExchange/dnscontrol"
  url "https://github.com/StackExchange/dnscontrol/archive/v3.3.0.tar.gz"
  sha256 "c8f7daa795af71622e4a78a9458d9e9fd5f1857b5ba87489ec46d22f9a9ca65c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d6125f6338b6f6d54f03f95fcbfde9e7a61876aa6709c87585f3e3601fbef56c" => :catalina
    sha256 "d694511167f6e819e24df4411e2a24fc918b48c6ccf90ea5f8cf2a99aa2a0b18" => :mojave
    sha256 "92e660190f6dcc8175ea31bea225bb1068f885e8e03a09ce154e157563c77e75" => :high_sierra
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
