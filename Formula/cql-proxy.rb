class CqlProxy < Formula
  desc "DataStax cql-proxy enables Cassandra apps to use Astra DB without code changes"
  homepage "https://github.com/datastax/cql-proxy"
  url "https://github.com/datastax/cql-proxy/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "961c002d9cdc12d78c37f35775e8a18f42f96657681894dd9e7edcb22e546c37"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cql-proxy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "589e915caffbbc8dec5b33f839f006798ab1bcbe53572641a32ab48cc16847ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    touch "secure.txt"
    output = shell_output("#{bin}/cql-proxy -b secure.txt --bind 127.0.0.1 2>&1", 1)
    assert_match "unable to open", output
  end
end
