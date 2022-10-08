class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.0",
      revision: "ce2f5a367a1495897a1c486ebfa7aa6d49175732"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cacd9aba8009fc2a24b9d5c7dc840a7193e21624a166a1a8e50c0e5b9e7bdb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c81c74ffbba2ff3fa278a0b356d3f9c809d832f2b4db453fc526efd68e2b14c"
    sha256 cellar: :any_skip_relocation, monterey:       "8edc8e1ddcfec3f9f1975e555043dd2cc91d3a14c9e9848afb2c6bea7531e1c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9c1ead19235a672fd908c8a14a04dca2ed0e97df68f0828d06f0a6b3c565073"
    sha256 cellar: :any_skip_relocation, catalina:       "1cbe3a759f0ec979a475e774792f407e115a9b4a241ef50f71465174f3c2b4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814658824bf1bf647766f1eb5381f7a2c9997a973284e4bfb6ecb63b885161da"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
