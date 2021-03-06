class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://manfred.life/assh"
  url "https://github.com/moul/assh/archive/v2.12.2.tar.gz"
  sha256 "bc22b229cac9f5c1f43b534788cfa0a024b6b70ed62eb215f81d443d571e10e8"
  license "MIT"
  head "https://github.com/moul/assh.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/assh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "173ce6e265c74a07963cafb038672b951f5c1011e46787afff0cdf2d60db86e2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assh_config = testpath/"assh.yml"
    assh_config.write <<~EOS
      hosts:
        hosta:
          Hostname: 127.0.0.1
      asshknownhostfile: /dev/null
    EOS

    output = "hosta assh ping statistics"
    assert_match output, shell_output("#{bin}/assh --config #{assh_config} ping -c 4 hosta 2>&1")
  end
end
