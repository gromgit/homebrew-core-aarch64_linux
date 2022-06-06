class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/v2.3.0.tar.gz"
  sha256 "e1866471dd3fc5d52fd18af5df489a25dca1168bf2517db2ee8fb976eee1e78a"
  license "MIT"
  head "https://github.com/filhodanuvem/gitql.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gitql"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "24d3c7ed85c7369d944f51af6b07760ac5e2f406baf68b783f84f8ccea47b3f0"
  end

  depends_on "go" => :build

  # Support 1.18 by updating dependencies.
  # Remove with the next release.
  patch do
    url "https://github.com/filhodanuvem/gitql/commit/1bad3899592b0a8265e4a9c66e1c26e0bcbcd111.patch?full_index=1"
    sha256 "b002683a2eac09f7342869cbbcb94a971f51db03fc7895bf7fa5a8069b030378"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "A U Thor"
    system "git", "config", "user.email", "author@example.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match "Initial commit", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
