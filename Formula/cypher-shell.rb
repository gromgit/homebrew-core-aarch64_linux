class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-4.4.9.zip"
  sha256 "5294bd16c21a3ccf383720c0157a3ea2de841b58b26439fde7f85dd347053578"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cypher-shell"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "cec6090446ea5585341ce84ea891f8901da48363cb110a1134740026f4b50302"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]

    # Needs the jar, but cannot go in bin
    libexec.install Dir["cypher-shell{,.jar}"]
    (bin/"cypher-shell").write_env_script libexec/"cypher-shell", Language::Java.overridable_java_home_env
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
