use Test2::V0 -no_srand;
use v5.42;
use Test2::Require::EnvVar 'TEST_TIE_GOOGLE_SHEETS_DOCUMENT_ID';
use Test2::Require::EnvVar 'TEST_TIE_GOOGLE_SERVICE_TOKEN';
use Tie::Google::Sheets;

subtest 'basic' => sub {

    tie my %doc, 'Tie::Google::Sheets', 
        spreadsheet_id  => $ENV{TEST_TIE_GOOGLE_SHEETS_DOCUMENT_ID},
        service_account => $ENV{TEST_TIE_GOOGLE_SERVICE_TOKEN},
        backoff_retry   => 8,
    ;

    is
        tied(%doc),
        object {
            prop isa => 'Tie::Google::Sheets';
        },
        'tied object is the right class',
    ;

    my $title_one = "foo-$$-" . time;
    my $sheet = tied(%doc)->add_worksheet($title_one);

    is
        tied(%$sheet),
        object {
            prop isa => 'Tie::Google::Sheets::Worksheet';
        },
        'sheet object is the right class',
    ;

    is $doc{$title_one}, D(), 'worksheet exists';

    is delete $doc{$title_one}, U(), 'delete worksheet';

    is $doc{$title_one}, U(), 'worksheet does not exist';
};

done_testing;