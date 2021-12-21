class Cjdns < Formula
  desc "Advanced mesh routing system with cryptographic addressing"
  homepage "https://github.com/cjdelisle/cjdns/"
  url "https://github.com/cjdelisle/cjdns/archive/cjdns-v21.2.tar.gz"
  sha256 "dec6ba261b423ea08e3a62a146ffd5db2b49a0b954a37fc37b24b35da2f7f773"
  license all_of: ["GPL-3.0-or-later", "GPL-2.0-or-later", "BSD-3-Clause", "MIT"]
  head "https://github.com/cjdelisle/cjdns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "5ba943bc0a44c52c2f23bae683e9fb28b7d1c11e76e5c6cfe7d97f5fbc65c1b1"
    sha256 cellar: :any_skip_relocation, big_sur:  "b57d1c38866eab0c671732fdf70890fde76e7b03a2fc6a3dc59d5dea29e9fbaa"
    sha256 cellar: :any_skip_relocation, catalina: "dc8c73f740f3bfbde7db45dde12cbc57bc34c925b88a15be55e4ba47b73eb1d4"
    sha256 cellar: :any_skip_relocation, mojave:   "6f5536caa2f432a96027fa223e20b12d54baa78f96a7d5cabb454ad380faf523"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    # Avoid using -march=native
    inreplace "node_build/make.js",
              "var NO_MARCH_FLAG = ['arm', 'ppc', 'ppc64'];",
              "var NO_MARCH_FLAG = ['x64', 'arm', 'arm64', 'ppc', 'ppc64'];"

    system "./do"
    bins = %w[cjdroute makekeys privatetopublic publictoip6 randombytes sybilsim]
    bin.install(*bins)

    # Avoid conflict with mkpasswd from `expect`
    bin.install "mkpasswd" => "cjdmkpasswd"

    man1.install "doc/man/cjdroute.1"
    man5.install "doc/man/cjdroute.conf.5"
  end

  test do
    sample_conf = JSON.parse(shell_output("#{bin}/cjdroute --genconf"))
    sample_private_key = sample_conf["privateKey"]
    sample_public_key = sample_conf["publicKey"]
    sample_ipv6 = IPAddr.new(sample_conf["ipv6"]).to_s

    expected_output = <<~EOS
      Input privkey: #{sample_private_key}
      Matching pubkey: #{sample_public_key}
      Resulting address: #{sample_ipv6}
    EOS

    assert_equal expected_output, pipe_output(bin/"privatetopublic", sample_private_key)
  end
end
