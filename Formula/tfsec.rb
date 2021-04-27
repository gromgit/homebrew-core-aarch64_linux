class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.25.tar.gz"
  sha256 "1df4ddaa8ebc57d1e6c10da62d26b60969a52f6bbe9bd8969ef37619bc34e832"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8f65b4d60d9e390f91a3e7c416f51e3b26fc2cca2b8b19baa55920e902d7a69"
    sha256 cellar: :any_skip_relocation, big_sur:       "39503f5d51bf206fd25af9b41b269b5bc5eca54371c5c75ab63b8b12a5e644a1"
    sha256 cellar: :any_skip_relocation, catalina:      "c512a8ab06be2440b165395cc00d30bbd6e504b4fcb5876f3944ea309c818827"
    sha256 cellar: :any_skip_relocation, mojave:        "8304e842138e9e367a694ddede22be50ccd0244ecb28cf26be9e740dfea3676d"
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
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    refute_match("WARNING", good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
