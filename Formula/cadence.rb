class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.27.0.tar.gz"
  sha256 "120c2080e8a03c32df6f2861a319779a5d678041595eaf871fa13941b2870a60"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec72fc8b05809cb1baa70c5c32f60202d245cb210148b34013de6b1eac1f309"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "099ead500467214dcf8a511e36ae144ba661389d81a5a1b509cb17d7c4789240"
    sha256 cellar: :any_skip_relocation, monterey:       "a23334f1434ba28a5e040f8546e639b708cc2ab4e0690aa6c4b99a9c4ec50229"
    sha256 cellar: :any_skip_relocation, big_sur:        "9731eebad147e6d6dd57d166e99ac03b72a5f5f0c3bcc97a73a61af065f7c881"
    sha256 cellar: :any_skip_relocation, catalina:       "4d5ecf72d1a9d0756155f6e69a6e01c0c6559063dc4b6b24e6fd13c58693d19c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24aad4d236583517eb5ff3164fff16c2e396f4a310c35809b54bd3de5e52aca"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
