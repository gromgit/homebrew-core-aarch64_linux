class Phpstan < Formula
  desc "PHP Static Analysis Tool"
  homepage "https://github.com/phpstan/phpstan"
  url "https://github.com/phpstan/phpstan/releases/download/1.7.3/phpstan.phar"
  sha256 "d8fa5beb746481ea81b1678ae34ed79c05c1b0b616b237e59f05bc5937c3fecf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38022d227ba4b34ab05ecb51e7fd68f1bebb2fe22d953e34ef2619652ad10e67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38022d227ba4b34ab05ecb51e7fd68f1bebb2fe22d953e34ef2619652ad10e67"
    sha256 cellar: :any_skip_relocation, monterey:       "98dcca55b7565eb168f5f567f3f6f22bfe36225cff2f816a7edcf3f3115e3f59"
    sha256 cellar: :any_skip_relocation, big_sur:        "98dcca55b7565eb168f5f567f3f6f22bfe36225cff2f816a7edcf3f3115e3f59"
    sha256 cellar: :any_skip_relocation, catalina:       "98dcca55b7565eb168f5f567f3f6f22bfe36225cff2f816a7edcf3f3115e3f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38022d227ba4b34ab05ecb51e7fd68f1bebb2fe22d953e34ef2619652ad10e67"
  end

  depends_on "php" => :test

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    pour_bottle? only_if: :default_prefix if Hardware::CPU.intel?
  end

  def install
    bin.install "phpstan.phar" => "phpstan"
  end

  test do
    (testpath/"src/autoload.php").write <<~EOS
      <?php
      spl_autoload_register(
          function($class) {
              static $classes = null;
              if ($classes === null) {
                  $classes = array(
                      'email' => '/Email.php'
                  );
              }
              $cn = strtolower($class);
              if (isset($classes[$cn])) {
                  require __DIR__ . $classes[$cn];
              }
          },
          true,
          false
      );
    EOS

    (testpath/"src/Email.php").write <<~EOS
      <?php
        declare(strict_types=1);

        final class Email
        {
            private string $email;

            private function __construct(string $email)
            {
                $this->ensureIsValidEmail($email);

                $this->email = $email;
            }

            public static function fromString(string $email): self
            {
                return new self($email);
            }

            public function __toString(): string
            {
                return $this->email;
            }

            private function ensureIsValidEmail(string $email): void
            {
                if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                    throw new InvalidArgumentException(
                        sprintf(
                            '"%s" is not a valid email address',
                            $email
                        )
                    );
                }
            }
        }
    EOS
    assert_match(/^\n \[OK\] No errors/,
      shell_output("#{bin}/phpstan analyse --level max --autoload-file src/autoload.php src/Email.php"))
  end
end
