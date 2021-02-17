class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.28.1",
  revision: "df6c1e88cdfd57cf61f80c9021f73a1df01f44c0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ace313a31af2f3e1187769a1ad7848ae33631a04b67c1f4a1251be47deea810"
    sha256 cellar: :any_skip_relocation, big_sur:       "ca178f5b6fa3824d4502a4e5fb1086322bfaa076f00151c1e0070487ebb01585"
    sha256 cellar: :any_skip_relocation, catalina:      "00799579ec4d3e0cc0655b12ced072523742e4e0a19a14568e5b7889c49467fe"
    sha256 cellar: :any_skip_relocation, mojave:        "b3a05a3763d8d43220291725e14ba82309e2f2860b49c39bf405cb8ad8067ccb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.Version=#{version}", "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: failed to validate account: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
