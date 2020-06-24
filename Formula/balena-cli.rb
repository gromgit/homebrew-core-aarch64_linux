require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-12.1.9.tgz"
  sha256 "8acd83f362660c654c9e6dd5a79377b7877109d194bd2c23bcb962fce8dc59cb"

  bottle do
    sha256 "b50d78486a57fc1467329cf54dbba718ab5c5ab0acd353d3609a47e544d4e07f" => :catalina
    sha256 "88524ff1c4fad49e50d82ccd3899c65dfda8a317155e75752ec6c0ed4921bd22" => :mojave
    sha256 "db902fa0ed768901121858705dd3b1ce49ea6f8b606a49de2bf9fa86cdad2566" => :high_sierra
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
