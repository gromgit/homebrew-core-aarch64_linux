require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.26.0.tgz"
  sha256 "20b07ea419c13cd89ad75978b9f891cd01b19d6e1699ee550fa9c9a2110a416d"

  bottle do
    sha256 "8641a6ee5794cee1ba98bc7e4ee0fbc36e79acccbd30777bd76477fe25f1070c" => :catalina
    sha256 "f16e3e18867ff790a276e6c36e52e88a7901826b13ee748ea8943ee43b5f8473" => :mojave
    sha256 "7e431f480ce1c4c603b926447bb673fc898ce65739ce05f35e165ba831630310" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
    assert_match "Logging in to balena-cloud.com", output
  end
end
