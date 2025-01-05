select * from tbl_book;
select * from tbl_book_authors;
select * from tbl_book_copies;
select * from tbl_book_loans;
select * from tbl_borrower;
select * from tbl_library_branch;
select * from tbl_publisher;

--> QUESTIONS:

--> Ques1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select  b.book_title, l.library_branch_branchname, sum(c.book_copies_no_of_copies) as total_no_of_copies
from tbl_book b
join tbl_book_copies c on b.book_bookid =  c.book_copies_bookid
join tbl_library_branch l on c.book_copies_branchid = l.library_branch_branchid
where book_title = 'The Lost Tribe' and library_branch_branchname = 'Sharpstown'
group by b.book_title, l.library_branch_branchname;

--> Ques2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select  b.book_title, l.library_branch_branchname, c.book_copies_no_of_copies as total_no_of_copies
from tbl_book b
join tbl_book_copies c on b.book_bookid =  c.book_copies_bookid
join tbl_library_branch l on c.book_copies_branchid = l.library_branch_branchid
where book_title = 'The Lost Tribe';

--> Ques3. Retrieve the names of all borrowers who do not have any books checked out.

select borrower_borrowername
from tbl_borrower
where borrower_cardno not in (select distinct(book_loans_cardno) from tbl_book_loans );

--> Ques4. For each book that is loaned out from the "Sharpstown" branch and whose DueDate is today, 
--> 		retrieve the book title, the borrower's name, and the borrower's address.

select b.book_title, r.borrower_borrowername, r.borrower_borroweraddress
from tbl_book b 
join tbl_book_loans n on b.book_bookid = n.book_loans_bookid
join tbl_library_branch l on l.library_branch_branchid = n.book_loans_branchid
join tbl_borrower r on n.book_loans_cardno = r.borrower_cardno
where n.book_loans_duedate = '2018-02-02' and l.library_branch_branchname = 'Sharpstown';

--> Ques5. For each library branch, retrieve the branch name and the total number of books loaned out from that branch.

select l.library_branch_branchid, l.library_branch_branchname, count(book_loans_branchid) total_no_of_book_loaned
from tbl_library_branch l
join tbl_book_loans b on l.library_branch_branchid = b.book_loans_branchid
group by l.library_branch_branchid, l.library_branch_branchname
order by l.library_branch_branchid;

--> Ques6. Retrieve the names, addresses, and number of books checked out for all borrowers 
-->        who have more than five books checked out.

select b.borrower_borrowername, b.borrower_borroweraddress, count(l.book_loans_cardno) as number_of_books_checked_out
from tbl_borrower b
join tbl_book_loans l on b.borrower_cardno = l.book_loans_cardno
group by b.borrower_borrowername, b.borrower_borroweraddress
having count(l.book_loans_cardno) > 5

--> Ques7. For each book authored by "Stephen King", retrieve the title and the number of 
--> 	   copies owned by the library branch whose name is "Central".

select a.book_authors_authorname, b.book_title, sum(c.book_copies_no_of_copies) as no_of_copies
from tbl_library_branch l
join tbl_book_copies c on l.library_branch_branchid = c.book_copies_branchid
join tbl_book b on c.book_copies_bookid = b.book_bookid
join tbl_book_authors a on b.book_bookid = a.book_authors_bookid
where l.library_branch_branchname = 'Central' 
group by a.book_authors_authorname, b.book_title
having a.book_authors_authorname = 'Stephen King';