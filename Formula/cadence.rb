class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.20.2.tar.gz"
  sha256 "ba64f5b5bb1050960c19ceca347ec982c05c87fd09f99c2861cc4f60baba04a3"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fe3d652c0d3744afaf169cdaa1d486969c3738cd57efc88bfce4db827d64181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7caaa265fdcd872b29f80469611a8490f0f3d8ebf625bf93523a9736ca42626e"
    sha256 cellar: :any_skip_relocation, monterey:       "50edc3ac81af3aa7c2ac82e84a8f47610f2ccab6fdad857e3232f25b36d6bad1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c96175aba9ec78e4b5c3ed347c4d51b7ab76f574004e8e4912206fed7d9f8041"
    sha256 cellar: :any_skip_relocation, catalina:       "8947c17a8dd114fc604b3e72bc0e0eee36145b8972121693bd0ff194e5315d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ed433e7f673d7820ebf326f65cfa8776329d3945a03cfa2569efbb172a0406"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
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
