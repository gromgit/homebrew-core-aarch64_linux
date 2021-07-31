class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/aquasecurity/tfsec/archive/v0.55.0.tar.gz"
  sha256 "5e42d835a7391e986ab496c858493dce170082cd5724424683043971a3fe2d83"
  license "MIT"
  head "https://github.com/aquasecurity/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f1b1063897bb2b3aaa32184f463c077d749edf8bc8693505a017f265fad832fc"
    sha256 cellar: :any_skip_relocation, big_sur:       "05d2c9d8559c7aa0b8cd211e72422d621e0cb3a786ada78f91eae92a9aadbcf1"
    sha256 cellar: :any_skip_relocation, catalina:      "e45ba5d82a3550f98c1b387dd1a3461fe10f5c5e4d622fb8faf096659d8eda7f"
    sha256 cellar: :any_skip_relocation, mojave:        "f6544e044f66b22396ed28afb7c81806cb354bd3bed83b8dfcaac0b436077c61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49ba29d4a794e7f40d082dc0de3b98ef6dbbce48b2989a628bd65b5f283e902b"
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
