require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.28.2.tgz"
  sha256 "d92fb0e54e1c5dc92c5451a1a919ce5b40f947d9d08c45ff122057abe33cccc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "df7f863ef58314c22c625e94c67ddac92947c680245cf922877a3ea071688050" => :catalina
    sha256 "4d00f15c2b63333e6eb7f3888d26f20f4932aee6c62df4be170b6aefeb9a8346" => :mojave
    sha256 "33dcd219d3885d9885b9e35ac7ede2aca416cb957fd434f555d6ef2e25cc721b" => :high_sierra
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
