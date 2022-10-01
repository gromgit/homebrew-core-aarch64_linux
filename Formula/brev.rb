class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.116.tar.gz"
  sha256 "2633e6fb33f34d53f4021749bdc6a46a88eca3c91883c763d03b1d25c4396dc0"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5586e902ec42a22e861b124b7ab028e88959c52be2fbcf25ce639b5494c54770"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca553ee59ffd0f587f05a0f6700efd1a55ded9c406706b9e9de71d6f2c66cfb8"
    sha256 cellar: :any_skip_relocation, monterey:       "cbdf48f63a739e85cd7264d91b3dd75b37191c961ff99a1075e4e741831221b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "16d0ec6d5a3e3695ef352719664576fb8d4a57a7da88012843e6cfa262645b2c"
    sha256 cellar: :any_skip_relocation, catalina:       "92cb1054804e51e82db12264ca0d47e2bfd660a5f493331d866aa66169168083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e762688f9684e097f62536c802b90fba3f5b6dc8d12e8bc6d0133901b283dc3c"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks instead of inet.af/netstack/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
