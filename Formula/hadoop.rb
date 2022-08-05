class Hadoop < Formula
  desc "Framework for distributed processing of large data sets"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz"
  sha256 "6a483d1a0b123490ebd8df3f71b64eb39f333f78b95f090aeb58e433cbc2416d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447be30cbb654379f96c9126a2763e5dab8edd85396caf82bd7516e01c540ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "447be30cbb654379f96c9126a2763e5dab8edd85396caf82bd7516e01c540ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "74357baa438fe8680aa00f0704e95bcfc558c0a8b0fff48f6b3716c846868525"
    sha256 cellar: :any_skip_relocation, big_sur:        "74357baa438fe8680aa00f0704e95bcfc558c0a8b0fff48f6b3716c846868525"
    sha256 cellar: :any_skip_relocation, catalina:       "74357baa438fe8680aa00f0704e95bcfc558c0a8b0fff48f6b3716c846868525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92cb92589ac48035f2482eca9321cebe31dfd3873272da601e24f30cc758cb5e"
  end

  depends_on "openjdk"

  conflicts_with "yarn", because: "both install `yarn` binaries"

  def install
    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin libexec share etc]
    Dir["#{libexec}/bin/*"].each do |path|
      (bin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/sbin/*"].each do |path|
      (sbin/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    Dir["#{libexec}/libexec/*.sh"].each do |path|
      (libexec/File.basename(path)).write_env_script path, JAVA_HOME: Formula["openjdk"].opt_prefix
    end
    # Temporary fix until https://github.com/Homebrew/brew/pull/4512 is fixed
    chmod 0755, Dir["#{libexec}/*.sh"]
  end

  test do
    system bin/"hadoop", "fs", "-ls"
  end
end
