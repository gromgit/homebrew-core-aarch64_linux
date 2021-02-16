class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
  tag:      "v2.28.0",
  revision: "5199bd35d3cffbfed3683b728828f55c64501c21"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fdd949819602c09ed3533d0b284070c8efa5d1176690128685d41b8cb8ccfa79"
    sha256 cellar: :any_skip_relocation, big_sur:       "64dfca55124c588a0550085c9bba5048e3747df684c66248f63b522879cdf23e"
    sha256 cellar: :any_skip_relocation, catalina:      "43b5b26c143c42ab2093cb5a6a3511b7417ec681a6130f73d22b64f9ff7b90ff"
    sha256 cellar: :any_skip_relocation, mojave:        "e4ca2bac31ead962d44e9769fd04e8d322c53a5f6e169a1d04e942eeb6bdd35e"
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
