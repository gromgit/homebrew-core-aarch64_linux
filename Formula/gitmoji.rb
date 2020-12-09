require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.15.tgz"
  sha256 "256a970bc10356cd54854370ad26c1bb7b6edcb2eaae9df6b10a553df25b91db"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4ab375f4a6ccb42fe06b7df8028edef3c148d0ce7edeab88f7c919e1f8f8406e" => :big_sur
    sha256 "efcf9af4133249d05960fcd69ebed10c09307967a843464b398081f1a32c6785" => :catalina
    sha256 "1e32af5596af98140aa0bae4e8a8e92177684fb6c077f96d057f973b5a312198" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
