require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.22.1.tgz"
  sha256 "fc94ddadae2843f5600dbb12b5b900807f2639a21a6dd2f52f8557f528e22e52"

  bottle do
    cellar :any_skip_relocation
    sha256 "71fa57c89c415a6f6b5ff40b75e4c9dc2ec4310cab51fdd79ede606ca6549254" => :catalina
    sha256 "35b07fc523297a0e94e29fa46453e4ece999294f3c1f8f083ebc3864cb62439a" => :mojave
    sha256 "2bf53046cef43c0dcb629260e4e75c471801f5625c39507a7ca15a42e05c2d80" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Please add either a client or service config", error_output
  end
end
