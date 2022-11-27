class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.12.1.tar.gz"
  sha256 "bba0012dda672d1c23e414f6a5da30a241dc8a0a212ff49236f880fcdf68e446"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/vsh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4ed2ce9b3bff908019a5a9231697bc5b2487dae3d5fee301037ddd0ce8914db1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.vshVersion=v#{version}"
  end

  test do
    version_output = shell_output("#{bin}/vsh --version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
