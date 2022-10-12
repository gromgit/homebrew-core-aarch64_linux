class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio.git",
      tag:      "1.15.2",
      revision: "b542583af7f8240ad0c9cab56eb9f8d55e1357ab"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6024a64484f0c67a29d6209e0c13e8b90d25924d5a85d19f4defdcd5b399080"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6024a64484f0c67a29d6209e0c13e8b90d25924d5a85d19f4defdcd5b399080"
    sha256 cellar: :any_skip_relocation, monterey:       "b4ca1cff5fc1f4373cffc38f905cb7ecb5f1049b1db0f5b9d0c2826b9967428e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4ca1cff5fc1f4373cffc38f905cb7ecb5f1049b1db0f5b9d0c2826b9967428e"
    sha256 cellar: :any_skip_relocation, catalina:       "b4ca1cff5fc1f4373cffc38f905cb7ecb5f1049b1db0f5b9d0c2826b9967428e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47be9623e692cec34eca7a781611efc551970062d38d5706b476ce997cda7850"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  uses_from_macos "curl" => :build

  def install
    ENV["VERSION"] = version.to_s
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s

    ENV.prepend_path "PATH", Formula["curl"].opt_bin if OS.linux?

    system "make", "istioctl"
    bin.install "out/#{os}_#{arch}/istioctl"

    generate_completions_from_executable(bin/"istioctl", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
