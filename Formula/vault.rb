# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      tag:      "v1.11.4",
      revision: "b47a9e72942719f217f7750df18be36ec21dfc0e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/vault/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c28617bb79b6ca246eb96bcbdd1276b8eab2db6e41c12345a05efe6c855c25"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "767e3f36daf5facccb512edf61c466e5c71c11085ed2f43d4797bb64f249ff66"
    sha256 cellar: :any_skip_relocation, monterey:       "69d2d0bf0bc42fc9c28eaffa637fd779bf64e834ffe795dc3d71e1b2005a2c69"
    sha256 cellar: :any_skip_relocation, big_sur:        "2808c461ff9104bb53235ea758d78929169630bbf0617ab670e9be687386186c"
    sha256 cellar: :any_skip_relocation, catalina:       "f0e9a1d7693bd02fde54721121efb0c786c1429b13236c72d9380e188a0047bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de7b8a4cccae3bf68696d3003f4e3124f94af405fe01bb59a02bf49347524f34"
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node" => :build
  depends_on "python@3.10" => :build
  depends_on "yarn" => :build

  def install
    # Needs both `npm` and `python` in PATH
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin" if OS.mac?
    ENV.prepend_path "PATH", "#{ENV["GOPATH"]}/bin"
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/vault"
  end

  service do
    run [opt_bin/"vault", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/vault.log"
    error_log_path var/"log/vault.log"
  end

  test do
    port = free_port
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = "127.0.0.1:#{port}"
    ENV["VAULT_ADDR"] = "http://127.0.0.1:#{port}"

    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 5
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
