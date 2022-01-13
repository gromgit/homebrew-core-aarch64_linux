class ImapBackup < Formula
  desc "Backup GMail (or other IMAP) accounts to disk"
  homepage "https://github.com/joeyates/imap-backup"
  url "https://github.com/joeyates/imap-backup/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "3fce5cbee17617d0284e3f4ad1261b3ba703374b2e14ffff0e29216abd90304d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ac7f1a3c41b30dba92269af4f9baf89b4886e75be0896f75ee923d40e3b9628"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac7f1a3c41b30dba92269af4f9baf89b4886e75be0896f75ee923d40e3b9628"
    sha256 cellar: :any_skip_relocation, big_sur:        "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, catalina:       "f72a3fe44b22389265183f5975115274276f8c534e4ead6d928f6cf073c5e3a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "356b64f9b6611dacf9ad9323b075f04687dcfee8f71277ad3cb6894e67926027"
  end

  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "Choose an action:", pipe_output(bin/"imap-backup setup", "3\n")
  end
end
