class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.58.5.tar.gz"
  sha256 "8708ba63af6c20d9ed6fbfa36cc6be8f1bad08a1195728f7926df0c74d95596e"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60b6600569bf00817594eed56485ecbf2061067bc0a2e8df09c15210904b6a39"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2d2453637b5dcac657d8719fbc3eb1a4ede732b3af19fe88d5a1a5b72c207c8"
    sha256 cellar: :any_skip_relocation, catalina:      "f22edf2f1bcd6551efd5ce632fb8ce1ee0588b2380f41963b1f0c712e9a9a620"
    sha256 cellar: :any_skip_relocation, mojave:        "76e925eeadee657ed9b7cc8d80bd5420532171fe8686d0d382d2deaae59facbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50f554553cc2d8d76395c47d65f23ee11c6163cff3c21c218cc72a80cefd7cec"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "1 potential problems detected.", bad_output
  end
end
