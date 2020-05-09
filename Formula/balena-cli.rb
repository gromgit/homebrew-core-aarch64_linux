require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.32.15.tgz"
  sha256 "f5f71e335d6d75c3d63167bcdff80ce98564cdd5adba64ab9a461e3f7eb79788"

  bottle do
    sha256 "4eeb1bc6c8a001faf531538555700adc07a1c260eecabe1493558c7bb7ad6238" => :catalina
    sha256 "61a7012469ae835d90f308aaaa2ca238d4195c5fc7235cec4599fea642e8aa48" => :mojave
    sha256 "8e4b16aa0d0e97e9e0116e028f2b3ab7e092b891df4791bc71d56359aa24d114" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
