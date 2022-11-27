class Cql < Formula
  desc "Decentralized SQL database with blockchain features"
  homepage "https://covenantsql.io"
  url "https://github.com/CovenantSQL/CovenantSQL/archive/v0.8.1.tar.gz"
  sha256 "73abb65106e5045208aa4a7cda56bc7c17ba377557ae47d60dad39a63f9c88a6"
  license "Apache-2.0"
  head "https://github.com/CovenantSQL/CovenantSQL.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cql"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "456579a4cde26efbb468bb64788b1adaf0fadc17fea79a8c29c478947734e04d"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  patch do
    url "https://github.com/CovenantSQL/CovenantSQL/commit/c1d5d81f5c27f0d02688bba41e29b84334eb438c.patch?full_index=1"
    sha256 "ebb9216440dc7061a99ad05be3dc7634db4260585f82966104a29a7c323c903d"
  end

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X github.com/CovenantSQL/CovenantSQL/conf.RoleTag=C
      -X github.com/CovenantSQL/CovenantSQL/utils/log.SimpleLog=Y
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "sqlite_omit_load_extension", "./cmd/cql"

    bash_completion.install "bin/completion/cql-completion.bash"
    zsh_completion.install "bin/completion/_cql"
  end

  test do
    testconf = testpath/"confgen"
    system bin/"cql", "generate", testconf
    assert_predicate testconf/"private.key", :exist?
    assert_predicate testconf/"config.yaml", :exist?
  end
end
