class Anyenv < Formula
  desc "All in one for **env"
  homepage "https://anyenv.github.io/"
  url "https://github.com/anyenv/anyenv/archive/v1.1.5.tar.gz"
  sha256 "ed086fb8f5ee6bd8136364c94a9a76a24c65e0a950bb015e1b83389879a56ba8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/anyenv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c234cba8a8456c97c8491b7aac3556ffde2719e86e3e467db7d4d458b5944e1c"
  end


  def install
    prefix.install %w[bin completions libexec]
  end

  test do
    Dir.mktmpdir do |dir|
      profile = "#{dir}/.profile"
      File.open(profile, "w") do |f|
        content = <<~EOS
          export ANYENV_ROOT=#{dir}/anyenv
          export ANYENV_DEFINITION_ROOT=#{dir}/anyenv-install
          eval "$(anyenv init -)"
        EOS
        f.write(content)
      end

      cmds = <<~EOS
        anyenv install --force-init
        anyenv install --list
        anyenv install rbenv
        rbenv install --list
      EOS
      cmds.split("\n").each do |cmd|
        shell_output(". #{profile} && #{cmd}")
      end
    end
  end
end
