require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.9.tgz"
  sha256 "45eca6860d1766cfae430aee09dbe0a6a51a27a731480016a9a4856d2cdcf386"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70819fb36259fd05cefadbf804cbc56dc54363a4ffb852acab17a43002bd2c71" => :catalina
    sha256 "49953c56e21686080e2d4a531aad981f3288893f4a733421fada8b60d82ad4fd" => :mojave
    sha256 "a1c859523ccd0c6432cd94777db4bd7430904dbdf83f96ec36bd76eb0f5f9504" => :high_sierra
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
