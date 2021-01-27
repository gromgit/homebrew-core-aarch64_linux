class Vsh < Formula
  desc "HashiCorp Vault interactive shell"
  homepage "https://github.com/fishi0x01/vsh"
  url "https://github.com/fishi0x01/vsh/archive/v0.8.0.tar.gz"
  sha256 "7eb6e2dcd758a38acfe12437e40d5f22a1f0cefa369dab9aeabd3417ae46ba12"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6adcf670bd110cc5a31dde92b63f971a45ba6ea226a97394dc41c78177c3e37" => :big_sur
    sha256 "66801dbbaf9dd30bfcc8924de726443b16eebc55c13f2a02f438b8dfb8f46eb4" => :arm64_big_sur
    sha256 "88da4d7e536488b80e76a019158b8e1344e9efc9dc26e7c3ae891f2537e533ce" => :catalina
    sha256 "115a71008dab242d2e7332cbf8e2fcd084db03b8df4e8c54023f27e004a636cb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.vshVersion=v#{version}"
  end

  test do
    version_output = shell_output("#{bin}/vsh -version")
    assert_match version.to_s, version_output
    error_output = shell_output("#{bin}/vsh -c ls 2>&1", 1)
    assert_match "Error initializing vault client | Is VAULT_ADDR properly set?", error_output
  end
end
