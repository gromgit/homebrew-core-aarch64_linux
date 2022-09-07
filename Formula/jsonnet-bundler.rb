class JsonnetBundler < Formula
  desc "Package manager for Jsonnet"
  homepage "https://github.com/jsonnet-bundler/jsonnet-bundler"
  url "https://github.com/jsonnet-bundler/jsonnet-bundler.git",
      tag:      "v0.4.0",
      revision: "447344d5a038562d320a3f0dca052611ade29280"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jsonnet-bundler"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ef7101e0711c89910cd840430272d2a9bd0d65ba7614ab3ac377c3207472d4de"
  end

  depends_on "go" => :build

  def install
    system "make", "static"
    bin.install "_output/jb"
  end

  test do
    assert_match "A jsonnet package manager", shell_output("#{bin}/jb 2>&1")

    system bin/"jb", "init"
    assert_predicate testpath/"jsonnetfile.json", :exist?

    system bin/"jb", "install", "https://github.com/grafana/grafonnet-lib"
    assert_predicate testpath/"vendor", :directory?
    assert_predicate testpath/"jsonnetfile.lock.json", :exist?
  end
end
