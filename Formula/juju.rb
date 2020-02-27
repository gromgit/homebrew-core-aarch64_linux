class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.3/+download/juju-core_2.7.3.tar.gz"
  sha256 "ff25f9a9e4ce2fcb5148be048bd5bb76c90fd5c7c185cff27d7eacc1d68afab2"

  bottle do
    cellar :any_skip_relocation
    sha256 "647274f7cd5f7035786a9230a7566f0ad34abaf09323fb08c49f31b848472c00" => :catalina
    sha256 "b36f8acc9463787f1372515a48bb6ff77485b270fc57b00c5ebd80116cd6490a" => :mojave
    sha256 "6409f80343ae97446bbc3d9d237688091c841450f2e1e2525d722db365082120" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
