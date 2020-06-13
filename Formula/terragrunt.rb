class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.23.26.tar.gz"
  sha256 "38af9f84abedefac767fd3898997f63df4178590e03c95644cf3f8390075b58a"

  bottle do
    cellar :any_skip_relocation
    sha256 "11fb909be2fc8343b19ad0f25ea12fd9206d50fadd2fe7b41a097c9c05f453c3" => :catalina
    sha256 "7b64614249898d96afde6f029988d5059f72faa56ef32f4ccf3c889262c6ea63" => :mojave
    sha256 "9f870c167eef1cef83927195d959fbb645e2ad186f234619cc31e3724a304692" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "terraform"

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
